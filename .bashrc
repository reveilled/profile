#do nothing if not interactive
[[ $- == *i* ]] || return

export FIRSTRUN=1

append_path_if_present()
{
	if [ -d $1 ]; then
		export PATH=$1:$PATH
	elif [ $FIRSTRUN -eq 0 ] ; then
		echo $1 not present to add to path
	fi
}

parse_git_branch(){
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}

unixish_aliases()
{
	alias ll="ls -l"
	alias llh="ls -lh"
	alias llah="ls -alh"
	alias lah="ls -ah"
	alias la="ls -a"
	alias less="less -r"
}

optional_alias()
{
	#Param 1 - alias
	#Param 2 - program to look for
	#Param 3 - warning if not installed

	if which $2 > /dev/null; then alias $1=$2; elif [ $FIRSTRUN -eq 0 ] ; then echo $3; fi
}

load_osx_settings()
{
	echo "Loading OSX settings..."
	export PS1="\[\033[96m\][\t]\[\033[00m\] \h:\W \u\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
	export PS2="and then... >"
	unixish_aliases
}

load_linux_settings()
{
	
	if [ ! -f /tmp/bashflag ]; then
		touch /tmp/bashflag
		export FIRSTRUN=0
	else
		export FIRSTRUN=1
	fi
	source /etc/skel/.bashrc > /dev/null

	export PS1="\[\033[96m\][\t]\[\033[00m\] \u@\h:\w \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
	export PS2="and then... >"
	unixish_aliases

	#use pigz instead of gzip
	optional_alias gzip pigz "pigz is not installed, consider installing it for parallel zipping"
	optional_alias cp gcp "gcp is not installed, consider installing it for more modern copying"
#	if which pigz > /dev/null; then alias gzip=pigz; else echo Pigz is not installed, consider installing it; fi
#	alias cp_old=`which cp`
#	alias cp="rsync -av "
}

load_os_settings(){
local os_name=`uname`

echo -e Loading OS Settings for \"$os_name\"

if [ $os_name = "Darwin" ]; then
	load_osx_settings
elif [ $os_name = "Linux" ]; then
	load_linux_settings
else
	echo Unknown OS, no settings to load
fi
}

targz_subdirs_of()
{
	pushd $1 > /dev/null
	for f in `find . -mindepth 1 -maxdepth 1 -type d`;
	do tar -czf $f.tar.gz $f;
		rm -rf $f;
	done
	popd > /dev/null
}
untargz_subdirs_of(){
	pushd $1 > /dev/null
	for f in *.tar.gz;
	do tar -xzf $f;
		rm $f;
	done
	popd > /dev/null

}

#dump last n commands to a script
# param 1 = number of commands
# param 2 = file to dump to
hist_to_script()
{
	local out_file=$2
	local num_commands=$1
	local hist_num=$((num_commands + 1))

    history $hist_num | head -$num_commands | sed 's/^ *[0-9]* *//' > $out_file
}

load_to_clipboard()
{
	cat $1 | xclip -selection c
}

todays_logins()
{
	cat /var/log/auth.log | grep keyring | grep "`date +"%b %e"`" | tr -s ' ' | cut -d ' ' -f 3
}

helpless()
{
	$@ --help | less
}

tar_dir_copy()
{
	tar c $1 | tar x -C $2
}

replace_string_in_file()
{
	local old_str=$1
	local new_str=$2
	local target_file=$3
	sed 's/$old_str/$new_str/g' $target_file > /tmp/edit-$target_file
	mv /tmp/edit-$target_file $target_file
}

pause_for_user_input()
{
	read -n1 -r -p "Press any key to continue..." key
}

psefg()
{
	ps -ef | grep -v grep | grep $1
}

psefg_pids()
{
	psefg $1 | tr -s ' ' | cut -d ' ' -f 2
}

whichbang()
{
	echo "#!" `which $1`
}

make_into_dir()
{
	mkdir $1 && cd $1
}
alias mid=make_into_dir

findin()
{
	local spath=${2:.}
	local fname=$1
	find $spath --iname "$fname"
}

rmfindin()
{
	local spath=${2:.}
	local fname=$1
	find $spath --iname "$fname" -exec rm {} \;
}

trim()
{
	awk '{$1=$1};1'
}

wccopy()
{
	local orig_string=$1
	local new_string=$2
	for f in ${@:3}; do tname=`echo $f | sed -e "s/$orig_string/$new_string/g"`; echo Copying $f to $tname; cp $f $tname; done
}

load_os_settings

if [ -f "~/.machinebashrc" ]; then
	source ~/.machinebashrc
elif [ $FIRSTRUN -eq 0 ] ; then
	echo "No machine specific setup"
fi
export FIRSTRUN=1
