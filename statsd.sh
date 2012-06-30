#!/bin/sh

#
# chkconfig: 35 99 20
# description: StatsD
#

. /etc/rc.d/init.d/functions

SERVICE_NAME="StatsD"
USER="root"

NODE_BINARY="/usr/local/bin/node"

PARAMS="/usr/local/statsd/stats.js /etc/statsd/local.js"
LOG_FILE="/var/log/statsd"
LOCK_FILE="/var/lock/subsys/statsd"


get_pid()
{
        CURRENT_PID=`ps -aefw | grep "$NODE_BINARY $PARAMS" | grep -v " grep " | awk '{print $2}'`
}


do_start()
{
        if [ ! -f "$LOCK_FILE" ] ; then
                echo -n $"Starting $SERVICE_NAME: "
                runuser -l "$USER" -c "$NODE_BINARY $PARAMS >> $LOG_FILE &" && echo_success || echo_failure
                RETVAL=$?
                echo
                [ $RETVAL -eq 0 ] && touch $LOCK_FILE
        else
                echo "$SERVICE_NAME appears to be running already. There is a lock file at $LOCK_FILE"
                RETVAL=1
        fi
}

do_stop()
{
        echo -n $"Stopping $SERVICE_NAME: "
        get_pid
        kill -9 $CURRENT_PID > /dev/null 2>&1 && echo_success || echo_failure
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f $LOCK_FILE
}

do_status()
{
        if [ ! -f "$LOCK_FILE" ] ; then
                echo "$SERVICE_NAME is not running."
                RETVAL=1
        else
                get_pid
                start_time=`ps -p $CURRENT_PID -o lstart | grep -v "STARTED"`
                echo "$SERVICE_NAME has been running since $start_time."
                RETVAL=0
        fi
}

case "$1" in
        start)
                do_start
                ;;
        stop)
                do_stop
                ;;
        status)
                do_status
                ;;
        restart)
                do_stop
                do_start
                ;;
        *)
                echo "Usage: $0 {start|stop|status|restart}"
                RETVAL=1
esac

exit $RETVAL

