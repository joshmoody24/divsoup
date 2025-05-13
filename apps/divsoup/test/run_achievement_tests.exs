ExUnit.start()

# Find all achievement test files
achievement_test_files = Path.wildcard("test/divdump/analyzer/achievements/**/*_test.exs")

# Require helper
Code.require_file("test/divdump/analyzer/achievements/test_helper.exs")

# Require each test file
Enum.each(achievement_test_files, &Code.require_file/1)

# Run the tests
ExUnit.run()