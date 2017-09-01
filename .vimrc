set smarttab " tab stopping
set tabstop=4
set softtabstop=4
set shiftwidth=4
set noexpandtab

set wrap
set ai
set cursorline
set showmatch " highlight matching brackets, etc

set wildmenu " autocomplete
set hlsearch " highlight matches

set foldenable "code folding
set foldlevelstart=10

"put backups in the tmp directory
set backup
set backupdir=./.backup,/tmp,.
set backupskip=/tmp/*
set directory=./.backup,/tmp,.
set writebackup

set mouse=v
set number
set ignorecase
syntax on
filetype on
filetype plugin on
filetype indent on " indent by filetype

autocmd FileType py set expandtab
autocmd FileType make set noexpandtab softtabstop=0
