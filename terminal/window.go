package terminal

import "strings"

type Window struct {
	Label   string
	Prompt  string
	Command string
	Lines   []WindowLine
}

type WindowLine struct {
	Text    string
	Command bool
}

func NewWindow(commands_and_output string, label string) (window *Window) {
	command_output_lines := strings.Split(commands_and_output, "\n")
	window = &Window{
		Label:  label,
		Prompt: "#",
		Lines:  make([]WindowLine, len(command_output_lines)),
	}
	for i, line := range command_output_lines {
		windowLine := WindowLine{
			Text:    line,
			Command: false,
		}
		if strings.HasPrefix(line, "# ") {
			windowLine.Text = line[2:]
			windowLine.Command = true
		}
		window.Lines[i] = windowLine
	}
	return
}
