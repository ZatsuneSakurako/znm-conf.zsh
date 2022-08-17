# From https://github.com/spaceship-prompt/spaceship-prompt/blob/b92b7d2ecb8ded6b1a0ff72617f0106bbe8dcc69/lib/utils.zsh#L9
__znm_cmd_exists() {
	command -v $1 > /dev/null 2>&1
}
