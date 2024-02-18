#!/bin/bash

set -e

builddir=${2:-mesonbuild.comb}

if [ ! -d "${builddir}" ]; then
	meson setup -- "${builddir}"
fi

OPTIONS=()
NDX_COMBO=1
NUM_COMBOS=1
COMBOS=()
FEATURES=()

add_option() {
	local option=$1
	shift
	if [ "${option}" == "docs" ]; then
		return 0  # skip docs option; use separate to test disabled docs
	fi
	declare -g -a "CHOICES_${option}"
	local -n choices="CHOICES_${option}"
	OPTIONS+=("${option}")
	choices=("$@")
	NUM_COMBOS=$((NUM_COMBOS * ${#choices[@]}))
	echo "Option ${option}; choices: $@"
}

parse_option() {
	local option=$(printf '%s' "$1" | jq -r '.name')
	local type=$(printf '%s' "$1" | jq -r '.type')
	# echo "Option: ${option} (${type})"
	case "${type}" in
	boolean)
		add_option "${option}" "true" "false"
		;;
	combo)
		# test features as "auto" only once
		readarray -t choices < <(printf '%s' "$1" | jq -r '.choices[] | select(. == "auto")')
		if [ "${#choices[@]}" = 1 ]; then
			FEATURES+=("${option}")
		fi
		readarray -t choices < <(printf '%s' "$1" | jq -r '.choices[] | select(. != "auto")')
		add_option "${option}" "${choices[@]}"
		;;
	*)
		echo >&2 "Unsupported option type ${type} for option ${option}"
		exit 1
		;;
	esac
}

parse_options() {
	while read -r jsonline; do
		parse_option "${jsonline}"
	done < <(
		meson introspect --buildoptions "${builddir}" \
		| jq -c 'sort_by(.name) | .[] | select(.section == "user" and (.type == "boolean" or .type == "combo")) | {name, type, choices}'
	)
}

test_combo() {
	echo "::group::Testing combination ${NDX_COMBO}/${NUM_COMBOS}: $@"
	meson configure "$@" -- "${builddir}"
	meson compile -C "${builddir}"
	meson test -C "${builddir}"
	NDX_COMBO=$((NDX_COMBO + 1))
	echo "::endgroup::"
}

build_combos() {
	local ndx=$1
	shift
	if [ "${ndx}" -lt "${#OPTIONS[@]}" ]; then
		local option="${OPTIONS[${ndx}]}"
		local -n choices="CHOICES_${option}"
		for choice in "${choices[@]}"; do
			build_combos $((ndx + 1)) "$@" "-D${option}=${choice}"
		done
	else
		test_combo "$@"
	fi
}

parse_options

NUM_COMBOS=$((NUM_COMBOS + ${#FEATURES[@]}))

# test feature detection
for feature in "${FEATURES[@]}"; do
	test_combo "-D${feature}=auto"
done

# test without docs (assume they are enabled by default and we run one default build first anyway)
build_combos 0 "-Ddocs=disabled"
