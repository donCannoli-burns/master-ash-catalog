package catalog

import (
	"os"
	"path/filepath"
	"testing"
)

func TestDetectLicense(t *testing.T) {
	d := t.TempDir()
	os.WriteFile(filepath.Join(d, "LICENSE"), []byte("MIT License\nPermission is hereby granted, free of charge"), 0644)
	l := DetectLicense(d)
	if l.Status != "allowed" || l.Name != "MIT" {
		t.Fatalf("%#v", l)
	}
}
func TestNoLicenseBlocks(t *testing.T) {
	l := DetectLicense(t.TempDir())
	if l.Status != "blocked" {
		t.Fatalf("%#v", l)
	}
}
