

append_path_if_present()
{
	if [ -d $1 ]; then
		export PATH=$1:$PATH
	else
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
	source /etc/skel/.bashrc > /dev/null
	export PS1="\[\033[96m\][\t]\[\033[00m\] \u@\h:\w \[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "
	export PS2="and then... >"
	unixish_aliases

	append_path_if_present /opt/platform-tools
	append_path_if_present /opt/ida-6.95
	append_path_if_present /opt/pycharm-community-2017.2.1/bin

	#use pigz instead of gzip
	if which pigz > /dev/null; then alias gzip=pigz; else echo Pigz is not installed, consider installing it; fi
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

load_os_settings
