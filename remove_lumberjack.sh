#!/bin/sh
#stop monit of lumberjack process
#stop lumberjack process
#uninstall lumberjack

monit=$(command -v monit)
if [ "$monit" != "" ]                           # if monit exists, unmonitor Lumberjack processes if any
    then
    monitored_lumberjack_processes=$(monit status | grep Process | grep lumberjack | awk ' { print $2 } ' | sed "s/'//g")

    if [[ "${#monitored_lumberjack_processes[@]}" > 0 ]]
        then
        for monitored_lumberjack_process in "${monitored_lumberjack_processes[@]}"
            do
            monit stop "$monitored_lumberjack_process"
            printf "monit stopped $monitored_lumberjack_process\n"
        done
    fi
else
    printf "monit not found\n"
fi

lumberjack_pid_files=(/var/run/*lumberjack*.pid)
if [[ "${#lumberjack_pid_files[@]}" > 0 ]]		# stop lumberjack processes if any
    then
    for lumberjack_pid_file in "${lumberjack_pid_files[@]}"
        do
        if [ -f $lumberjack_pid_file ]; then
            PID=`cat $lumberjack_pid_file`
            kill -HUP $PID
            rm -f $lumberjack_pid_file
            printf "killed $lumberjack_pid_file\n"
        else
            printf "$lumberjack_pid_file doesn't exit\n"
        fi
    done
fi