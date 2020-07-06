usage() {
    echo "usage: fusesoc_manager.sh [args]"
    echo "--init        initialize cores remote library"
    echo "--setup       setup core sources from remote"
}

ARGS=()
while [[ $# -gt 0 ]]; do
    case "$1" in
    --init)
        init=true
        shift
        shift
        ;;
    --setup)
        core=$2
        root_dir=$3
        tool=$4
        target=$5
        shift
        shift
        shift
        shift
        shift
        ;;
    -h|--help)
        usage
        exit 0
        ;;
    *)
        echo "Unrecognized argument"
        usage
        exit 1
        ;;
    esac
done

if [ "$init" = true ] ; then
    fusesoc init -y
    fusesoc library add symbiflow-cores https://github.com/antmicro/symbiflow-cores.git --global
else
    fusesoc fetch $core
    # This step is for generating sources only from FuseSoC core (we use default tool)
    fusesoc --cores-root=$root_dir run --tool=$tool --target=$target --setup $core
fi

