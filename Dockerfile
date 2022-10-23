# コンテナのベースイメージを指定
# alpine linux OS は非常に軽量に特化したOSである。
FROM ruby:2.7.2-alpine

# このDockerfile内でしか使用できない変数を定義する。WORKDIRにはappが代入される。
ARG WORKDIR
ARG RUNTIME_PACKAGES="nodejs tzdata postgresql-dev postgresql git"
ARG DEV_PACKAGES="build-base curl-dev"

# 環境変数を定義（Dockerfile, コンテナ参照可）。TZとはTimeZoneの略。
ENV HOME=/${WORKDIR} \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo

# ベースイメージに対してコマンドを実行する
# Dockerfile内で変数を使うときは、${}または${}と書く
# HOMEという変数は、ENV命令内で指定しているもの
# ENV命令内で指定しているHOMEには、WORKDIRが代入されているが、WORKDIRにはappが代入されているため、
# ここではappが出力されることになる。
# RUN echo ${HOME}

# Dockerfile内で指定した5つの命令を実行する（RUN, COPY, ADD, ENTRYPOINT, CMD）
# 作業ディレクトリを定義
WORKDIR ${HOME}

# ホスト側(PC)のファイルをコンテナにコピー
COPY Gemfile* ./

RUN apk update && \
    apk upgrade && \
    apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --virtual build-dependencies --no-cache ${DEV_PACKAGES} && \
    bundle install -j4 && \
    # パッケージを削除（Dockerイメージを軽量化するため）
    apk del build-dependencies

# . はDockerfileがあるディレクトリ全てのファイル（サブディレクトリも含む）
COPY . ./

# コンテナ内で実行したいコマンドを定義
# -b は、バインドのこと。プロセスを指定したIP(0.0.0.0)アドレスに紐付け（バインド）するために書いている。
# なぜそれが必要なのかというと、コンテナになるRailsは、外部にあるローカルPC（ホスト）からは見えないから。
# ホスト（PC）|  コンテナ
# ブラウザ(外部) | Rails
CMD ["rails", "server", "-b", "0.0.0.0"]