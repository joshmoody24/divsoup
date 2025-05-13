# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build/Test Commands
- `mix deps.get` - Install dependencies
- `mix test` - Run all tests
- `mix test path/to/test_file.exs` - Run specific test file
- `mix test path/to/test_file.exs:line_number` - Run specific test
- `mix test test/divdump/analyzer/achievements/**/silver*` - Test pattern matching
- `mix run apps/divsoup/test/run_achievement_tests.exs` - Run all achievement tests
- `mix format` - Format code
- `mix format --check-formatted` - Check formatting

## Code Style Guidelines
- **Module Structure**: Achievements in achievements/[group]/[level].ex with tests in same path structure
- **Naming**: CamelCase for modules, snake_case for functions/variables
- **Documentation**: @moduledoc for modules, @doc for public functions with examples
- **Types**: Define @type specs and use @spec for function signatures
- **Callbacks**: Use @callback for behavior definitions and @impl true when implementing
- **Error Handling**: Return error list when achievement not met, empty list when met
- **Functions**: Keep functions small and focused, prefer pattern matching over conditionals
- **Testing**: Use helper functions assert_achievement_earned/not_earned for consistency