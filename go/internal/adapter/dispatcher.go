package adapter

import (
	"context"
	"core/internal/app"
	"core/internal/logger"
	"core/pkg/pb"
	"fmt"

	"google.golang.org/protobuf/proto"
)

// Dispatcher handles protobuf action dispatch at the adapter boundary
// It converts between protobuf types and domain types
type Dispatcher struct {
	app *app.App
}

// NewDispatcher creates a new dispatcher
func NewDispatcher(a *app.App) *Dispatcher {
	return &Dispatcher{app: a}
}

// Dispatch handles an action and returns a protobuf response
// Context is passed through for cancellation support
func (d *Dispatcher) Dispatch(ctx context.Context, action pb.Action, payload []byte) (response proto.Message, err error) {
	defer func() {
		if r := recover(); r != nil {
			err = fmt.Errorf("internal panic: %v", r)
		}
	}()

	switch action {
	case pb.Action_ACTION_GET_NEARBY_SCHOOLS:
		req := &pb.RangeSearchRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		res, err := d.app.GetNearbySchools(ctx, req.UserLatitude, req.UserLongitude, req.Range)
		if err != nil {
			return nil, err
		}
		return &pb.RangeSearchResponse{Schools: SchoolsWithDistanceToProto(res)}, nil

	case pb.Action_ACTION_GET_FAVORITE_SCHOOLS:
		schools, err := d.app.GetFavoriteSchools(ctx)
		if err != nil {
			return nil, err
		}
		return &pb.SchoolListResponse{Schools: SchoolsToProto(schools)}, nil

	case pb.Action_ACTION_ADD_FAVORITE:
		req := &pb.FavoriteRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		return nil, d.app.AddFavorite(ctx, req.SchoolId)

	case pb.Action_ACTION_REMOVE_FAVORITE:
		req := &pb.FavoriteRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		return nil, d.app.RemoveFavorite(ctx, req.SchoolId)

	case pb.Action_ACTION_SAVE_MAP_STATE:
		req := &pb.MapState{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		return nil, d.app.SaveMapState(ctx, ProtoToMapState(req))

	case pb.Action_ACTION_GET_MAP_STATE:
		state, err := d.app.GetMapState(ctx)
		if err != nil {
			return nil, err
		}
		return MapStateToProto(state), nil

	case pb.Action_ACTION_SEARCH_BASIC:
		req := &pb.SearchRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		schools, err := d.app.SearchSchools(ctx, req.Keyword)
		if err != nil {
			return nil, err
		}
		return &pb.SchoolListResponse{Schools: SchoolsToProto(schools)}, nil

	case pb.Action_ACTION_SEARCH_ADVANCED:
		req := &pb.AdvancedSearchRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		schools, err := d.app.AdvancedSearch(ctx, ProtoToAdvancedSearchCriteria(req))
		if err != nil {
			return nil, err
		}
		return &pb.SchoolListResponse{Schools: SchoolsToProto(schools)}, nil

	case pb.Action_ACTION_GET_SCHOOL_DETAILS:
		req := &pb.GetSchoolByIdRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		school, err := d.app.GetSchoolByID(ctx, req.Id)
		if err != nil {
			return nil, err
		}
		if school == nil {
			return nil, fmt.Errorf("school not found")
		}
		return SchoolToProto(school), nil

	case pb.Action_ACTION_UPDATE_SETTINGS:
		req := &pb.UserSettings{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		return nil, d.app.UpdateSettings(ctx, ProtoToUserSettings(req))

	case pb.Action_ACTION_GET_SETTINGS:
		settings, err := d.app.GetSettings(ctx)
		if err != nil {
			return nil, err
		}
		return UserSettingsToProto(settings), nil

	case pb.Action_ACTION_GET_FILTER_OPTIONS:
		options, err := d.app.GetFilterOptions(ctx)
		if err != nil {
			return nil, err
		}
		return FilterOptionsToProto(options), nil

	case pb.Action_ACTION_RELOAD_DATA:
		return nil, d.app.ReloadData(ctx)

	case pb.Action_ACTION_SET_DEBUG_MODE:
		req := &pb.SetDebugModeRequest{}
		if err := proto.Unmarshal(payload, req); err != nil {
			return nil, err
		}
		logger.Get().SetDebug(req.Enabled)
		return nil, nil

	default:
		return nil, fmt.Errorf("unknown action: %v", action)
	}
}
