cod_dir=$(pwd)

log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head(){
  echo -e " \e[35m$1\e[0m "
}

status_check(){
  if [ $1 -eq o ]; then
    echo SUCCESS
    else
    echo FAILURE
    fi

}