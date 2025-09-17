#!/bin/sh
#PBS -q rt_HG
#PBS -l select=1
#PBS -l walltime=1:23:45
#PBS -P gag51492

# デフォルトで定義されている環境変数を表示する
vars=(PBS_ENVIRONMENT PBS_JOBID PBS_JOBNAME PBS_NODEFILE PBS_LOCALDIR PBS_O_WORKDIR PBS_ARRAY_INDEX)
for var in "${vars[@]}"; do
  printf "%-15s = %s\n" "$var" "${!var}"
done

# ログの出力先を設定する
export OUTPUTS_DIRPATH="${PBS_O_WORKDIR}/outputs/${PBS_JOBID}"
export LOG_FILE_PATH="${OUTPUTS_DIRPATH}/abci.log"
exec >"$LOG_FILE_PATH" 2>&1

# ジョブ投入時の作業ディレクトリへのパスに移動する
cd ${PBS_O_WORKDIR}

# モジュールの初期設定をする
# https://docs.abci.ai/v3/ja/environment-modules/
source /etc/profile.d/modules.sh

# 使用するモジュールをロードする
module load cuda/12.6/12.6.1

# mise がインストールされているか確認する
if ! command -v mise >/dev/null 2>&1; then
  echo "Error: mise is not installed. Aborting job."
  exit 1
fi

# .mise.toml が存在するか確認する
if [ ! -f "${PWD}/.mise.toml" ]; then
  echo "Error: .mise.toml not found in ${PWD}. Aborting job."
  exit 1
fi

# プロジェクト直下の .mise/ にツール本体を入れる
export MISE_DATA_DIR="${PWD}/.mise"
eval "$(mise activate sh)"
# .mise.toml (or .tool-versions) を見てインストール
mise install -y

echo python --version
echo uv --version

# uvでPythonの依存をインストールする
# uv sync

# 環境変数CMDとして渡された文字列をコマンドとして実行する
# プロンプトインジェクションには注意
# eval "$CMD"