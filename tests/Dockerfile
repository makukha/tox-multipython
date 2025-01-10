FROM makukha/multipython:unsafe
SHELL ["/bin/bash", "-o", "errexit", "-o", "errtrace", "-o", "nounset", "-o", "pipefail", "-c"]

RUN <<EOT
    # remove version pre-installed with multipython
    python -m pip uninstall -y tox virtualenv-multipython
EOT

COPY dist /test/dist
COPY tests/tox.*.ini /test/tests/
WORKDIR /test/tests

ARG TOX_TAG
RUN <<EOT
    set -eEux -o pipefail
    # install tox and current plugin version
    $(py bin --path "$TOX_TAG") -m pip install "tox>=3,<4" wheel
    $(py bin --path "$TOX_TAG") -m pip install ../dist/*.whl
EOT

ARG CASE_NAME
ARG TAGS_PASSING
ARG TAGS_INVALID
ARG TAGS_NOTFOUND
RUN <<EOT
    set -eEux -o pipefail
    echo_success () {
      echo "TEST CASE PASSED: ${CASE_NAME}" >&2
    }

    TOX="$(py bin --path "$TOX_TAG") -m tox"
    # make sure all tags mentioned
    (sed 's/ $//; s/ /\n/g' <<<"$TAGS_PASSING $TAGS_INVALID" | sort) | diff -s - <(py ls --tag | sort)

    # this is needed to not interfere with virtualenv-multipython
    export VIRTUALENV_DISCOVERY=

    # passing
    sed 's/{env:ENVS}/'"$(tr ' ' , <<<"$TAGS_PASSING")"'/' tox.passing.ini > tox.ini
    $TOX run -e ALL -v

    # invalid
    if [ -n "$TAGS_INVALID" ]; then
        sed 's/{env:ENVS}/'"$(tr ' ' , <<<"$TAGS_INVALID")"'/' tox.failing.ini > tox.ini
        for TAG in $TAGS_INVALID; do
          [[ "$($TOX run -e $TAG)" == *" invocation failed "* ]]
        done
    fi

    # not found
    sed 's/{env:ENVS}/'"$(tr ' ' , <<<"$TAGS_NOTFOUND")"'/' tox.failing.ini > tox.ini
    for TAG in $TAGS_NOTFOUND; do
      [[ "$($TOX run -e $TAG)" == *" InterpreterNotFound:"* ]]
    done

    echo_success
EOT
