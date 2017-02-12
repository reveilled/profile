set smarttab " tab stopping
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set wrap
set ai
set cursorline
filetype indent on " indent by filetype
set showmatch " highlight matching brackets, etc

set wildmenu " autocomplete
set hlsearch " highlight matches

set foldenable "code folding
set foldlevelstart=10

"put backups in the tmp directory
set backup
set backupdir=/tmp/.vimtmp
set backupskip=/tmp/*
set directory=/tmp/.vimtmp
set writebackup

set mouse=a
set number
set ignorecase
syntax on
