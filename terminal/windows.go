package terminal

func LoadWindowsFromData(assets map[string]string) (windows map[string]*Window) {
	windows = map[string]*Window{}
	for name, asset := range assets {
		windows[name] = NewWindow(asset, name)
	}
	return
}
