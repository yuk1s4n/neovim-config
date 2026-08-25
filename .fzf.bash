# Setup fzf
# ---------
if [[ ! "$PATH" == */home/yuk1s4n/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/yuk1s4n/.fzf/bin"
fi

eval "$(fzf --bash)"
# export FZF_DEFAULT_OPTS="--preview 'fzf-preview.sh {}'"
# export FZF_DEFAULT_OPTS='--preview '$HOME/fzf-preview.sh {}''
export FZF_DEFAULT_OPTS="
--walker=file,dir,follow,hidden --walker-root=$HOME
--style full
--border --padding 1,2
--border-label ' Demo ' --input-label ' Input ' --header-label ' File Type '
--preview 'fzf-preview.sh {}'
--preview-window 'right,60%'
--bind 'result:transform-list-label:
if [[ -z \$FZF_QUERY ]]; then
    echo \" \$FZF_MATCH_COUNT items \"
else
    echo \" \$FZF_MATCH_COUNT matches for [\$FZF_QUERY] \"
fi
'
--bind 'focus:transform-preview-label:[[ -n {} ]] && printf \" Previewing [%s] \" {}'
--bind 'focus:+transform-header:file --brief {} || echo \"No file selected\"'
--bind 'ctrl-r:change-list-label( Reloading the list )+reload(sleep 2; git ls-files)'
--color 'border:#aaaaaa,label:#cccccc'
--color 'preview-border:#9999cc,preview-label:#ccccff'
--color 'list-border:#669966,list-label:#99cc99'
--color 'input-border:#996666,input-label:#ffcccc'
--color 'header-border:#6699cc,header-label:#99ccff'
"
