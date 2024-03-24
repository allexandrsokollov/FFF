REPO_DIR := $(git rev-parse --show-toplevel)
DIRS = backend
PRETTY_DIRS = alembic


.PHONY: validate
validate:  ## Прогон валидаторов
	poetry run toml-sort --check pyproject.toml
	poetry run black --check $(DIRS) $(PRETTY_DIRS)
	poetry run isort --check $(DIRS) $(PRETTY_DIRS)
	poetry run autoflake --quiet --recursive --check $(DIRS) $(PRETTY_DIRS)
	make mypy
	make pylint

pretty:  ## "Причесать" код - isort, black, пр.
	poetry run toml-sort --in-place --all pyproject.toml
	poetry run black $(DIRS) $(PRETTY_DIRS)
	poetry run isort $(DIRS) $(PRETTY_DIRS)
	poetry run autoflake --in-place --verbose --recursive --remove-all-unused-imports --ignore-init-module-imports --exclude=alembic/env.py $(DIRS) $(PRETTY_DIRS)


.PHONY: black
black:  ## Отдельный запуск Black
	poetry run black --check $(DIRS) $(PRETTY_DIRS) --diff

.PHONY: pylint
pylint:  ## Отдельный запуск Pylint
	poetry run pylint --jobs 4 --extension-pkg-whitelist='pydantic' tests

.PHONY: mypy
mypy:  ## Отдельный запуск mypy
	poetry run mypy --show-error-codes $(DIRS)
