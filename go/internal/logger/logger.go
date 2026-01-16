package logger

import (
	"os"
	"sync"

	"github.com/sirupsen/logrus"
)

var (
	instance *Logger
	once     sync.Once
)

// Logger provides a simple logging interface wrapping Logrus
type Logger struct {
	logger *logrus.Logger
}

// Get returns the global logger instance
func Get() *Logger {
	once.Do(func() {
		l := logrus.New()
		l.SetOutput(os.Stdout)
		// TextFormatter is easier to read in Flutter debug console than JSON
		l.SetFormatter(&logrus.TextFormatter{
			ForceColors:   true,
			FullTimestamp: true,
		})
		l.SetLevel(logrus.ErrorLevel) // Default to Error, wait for Debug signal

		instance = &Logger{
			logger: l,
		}
	})
	return instance
}

// SetDebug enables or disables debug logging
func (l *Logger) SetDebug(enabled bool) {
	if enabled {
		l.logger.SetLevel(logrus.DebugLevel)
		l.logger.Info("Logger switched to DEBUG level")
	} else {
		l.logger.Info("Logger switched to ERROR level")
		l.logger.SetLevel(logrus.ErrorLevel)
	}
}

// D logs a debug message
func (l *Logger) D(tag string, msg string, args ...any) {
	l.logger.WithFields(logrus.Fields{
		"tag": tag,
	}).Debugf(msg, args...)
}

// E logs an error message
func (l *Logger) E(tag string, msg string, err error) {
	entry := l.logger.WithFields(logrus.Fields{
		"tag": tag,
	})
	if err != nil {
		entry = entry.WithError(err)
	}
	entry.Error(msg)
}

// I logs an info message
func (l *Logger) I(tag string, msg string, args ...any) {
	l.logger.WithFields(logrus.Fields{
		"tag": tag,
	}).Infof(msg, args...)
}
