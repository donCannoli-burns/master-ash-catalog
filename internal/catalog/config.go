package catalog

import (
	"encoding/json"
	"fmt"
	"os"
)

func LoadConfig(path string) (Config, error) {
	b, err := os.ReadFile(path)
	if err != nil {
		return Config{}, err
	}
	var c Config
	if err := json.Unmarshal(b, &c); err != nil {
		return Config{}, fmt.Errorf("decode %s: %w", path, err)
	}
	if c.Name == "" {
		return Config{}, fmt.Errorf("config name is required")
	}
	if c.UnofficialName == "" {
		c.UnofficialName = c.Name
	}
	return c, nil
}

func WriteJSON(path string, v any) error {
	b, err := json.MarshalIndent(v, "", "  ")
	if err != nil {
		return err
	}
	b = append(b, '\n')
	return os.WriteFile(path, b, 0o644)
}
