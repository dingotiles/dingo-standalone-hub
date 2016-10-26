package terminal

import "testing"

func TestTerminal_NewWindow_Empty(t *testing.T) {
	t.Parallel()
	window := NewWindow("", "empty")
	if window.Label != "empty" {
		t.Fatalf(".Label should be 'empty', instead: %s", window.Label)
	}
	if window.Prompt != "#" {
		t.Fatalf(".Prompt should be '#', instead: %s", window.Prompt)
	}
}

func TestTerminal_NewWindow_OneCommand(t *testing.T) {
	t.Parallel()
	window := NewWindow("# some-command", "one-command")
	if len(window.Lines) != 1 {
		t.Fatalf("expect 1 .Lines, instead: %#v", window.Lines)
	}
	if window.Lines[0].Text != "some-command" {
		t.Fatalf("expect .Lines[0].Text to be 'some-command', instead: %#v", window.Lines[0].Text)
	}
	if !window.Lines[0].Command {
		t.Fatalf("expect .Lines[0].Command to be true, instead: %#v", window.Lines[0].Command)
	}
}

func TestTerminal_NewWindow_NewlineOutput(t *testing.T) {
	t.Parallel()
	window := NewWindow("line1\n\nline3", "newline-output")
	if len(window.Lines) != 3 {
		t.Fatalf("expect 3 .Lines, instead: %#v", window.Lines)
	}
	if window.Lines[0].Text != "line1" {
		t.Fatalf("expect .Lines[0].Text to be 'line1', instead: %#v", window.Lines[0].Text)
	}
	if window.Lines[1].Text != "" {
		t.Fatalf("expect .Lines[1].Text to be '', instead: %#v", window.Lines[1].Text)
	}
	if window.Lines[2].Text != "line3" {
		t.Fatalf("expect .Lines[2].Text to be 'line3', instead: %#v", window.Lines[0].Text)
	}
}

func TestTerminal_NewWindow_CommandAndOutput(t *testing.T) {
	t.Parallel()
	window := NewWindow("# some-command\nsome\noutput", "command-and-output")
	if len(window.Lines) != 3 {
		t.Fatalf("expect 3 .Lines, instead: %#v", window.Lines)
	}
	if window.Lines[0].Text != "some-command" {
		t.Fatalf("expect .Lines[0].Text to be 'some-command', instead: %#v", window.Lines[0].Text)
	}
	if !window.Lines[0].Command {
		t.Fatalf("expect .Lines[0].Command to be true, instead: %#v", window.Lines[0].Command)
	}
	if window.Lines[1].Text != "some" {
		t.Fatalf("expect .Lines[1].Text to be 'some', instead: %#v", window.Lines[1].Text)
	}
	if window.Lines[1].Command {
		t.Fatalf("expect .Lines[1].Command to be false, instead: %#v", window.Lines[1].Command)
	}
	if window.Lines[2].Text != "output" {
		t.Fatalf("expect .Lines[2].Text to be 'output', instead: %#v", window.Lines[2].Text)
	}
	if window.Lines[2].Command {
		t.Fatalf("expect .Lines[2].Command to be false, instead: %#v", window.Lines[2].Command)
	}
}

func TestTerminal_NewWindow_TwoCommandsAndOutput(t *testing.T) {
	t.Parallel()
	window := NewWindow("# command1\noutput1\n# command2\noutput2", "two-commands")
	if len(window.Lines) != 4 {
		t.Fatalf("expect 1 .Lines, instead: %#v", window.Lines)
	}
	if window.Lines[0].Text != "command1" {
		t.Fatalf("expect .Lines[0].Text to be 'command1', instead: %#v", window.Lines[0].Text)
	}
	if !window.Lines[0].Command {
		t.Fatalf("expect .Lines[0].Command to be true, instead: %#v", window.Lines[0].Command)
	}
	if window.Lines[1].Text != "output1" {
		t.Fatalf("expect .Lines[0].Text to be 'output1', instead: %#v", window.Lines[1].Text)
	}
	if window.Lines[1].Command {
		t.Fatalf("expect .Lines[0].Command to be true, instead: %#v", window.Lines[1].Command)
	}
	if window.Lines[2].Text != "command2" {
		t.Fatalf("expect .Lines[2].Text to be 'command2', instead: %#v", window.Lines[2].Text)
	}
	if !window.Lines[2].Command {
		t.Fatalf("expect .Lines[2].Command to be true, instead: %#v", window.Lines[2].Command)
	}
	if window.Lines[3].Text != "output2" {
		t.Fatalf("expect .Lines[0].Text to be 'output2', instead: %#v", window.Lines[3].Text)
	}
	if window.Lines[3].Command {
		t.Fatalf("expect .Lines[0].Command to be true, instead: %#v", window.Lines[3].Command)
	}
}
