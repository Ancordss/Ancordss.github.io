bd:
	hugo server --buildDrafts
b:
	hugo server
np:
	hugo new content/post/$(FILENAME).md
# Makefile

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Available targets:"
	@echo "  np FILENAME=<name>   Create a new Markdown file in content/posts/ with the specified name."
	@echo "  b  start hugo server."
	@echo "  bd start hugo server buildDrafts"
