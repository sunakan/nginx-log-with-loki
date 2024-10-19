.PHONY: up
up: ## サーバーを起動
	@docker compose up

.PHONY: down
down: ## サーバーを停止
	@docker compose down

.PHONY: clean-for-nginx
clean-for-nginx: ## Nginxのlogをキレイにする
	@rm -rf nginx/var/log/nginx/*.log

.PHONY: clean-for-loki
clean-for-loki: ## Lokiが保存したデータをキレイにする
	@rm -rf loki/loki/
	@mkdir -p loki/loki/
	@touch loki/loki/.gitkeep

################################################################################
# Utility-Command help
################################################################################
.DEFAULT_GOAL := help

################################################################################
# マクロ
################################################################################
# Makefileの中身を抽出してhelpとして1行で出す
# $(1): Makefile名
# 使い方例: $(call help,{included-makefile})
define help
  grep -E '^[\.a-zA-Z0-9_-]+:.*?## .*$$' $(1) \
  | grep --invert-match "## non-help" \
  | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'
endef

################################################################################
# タスク
################################################################################
.PHONY: help
help: ## Make タスク一覧
	@echo '######################################################################'
	@echo '# Makeタスク一覧'
	@echo '# $$ make XXX'
	@echo '# or'
	@echo '# $$ make XXX --dry-run'
	@echo '######################################################################'
	@echo $(MAKEFILE_LIST) \
	| tr ' ' '\n' \
	| xargs -I {included-makefile} $(call help,{included-makefile})
