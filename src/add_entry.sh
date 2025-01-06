#!/bin/sh

year=$(date +%G)
month=$(date +%m)
day=$(date +%d)
week=$(date +%W)

echo "Today is $year / $month / $day"

if [ ! -d "$year" ]; then
    mkdir $year
    mkdir $year/images
    cd $year
    ln -s ../images/university_logo.eps .
    ln -s ../images/university_logo.png .
    ln -s ../src/research_diary.sty .
    ln -s ../src/clean.sh clean
    ln -s ../src/compile_today.sh compile_today
    cd ..
fi

if [ -d "$year" ]; then
    echo "Adding new entry to directory $year."
fi

cd $year
filename="$week"_main.tex
dirname="$week"_week

#Add a new directory with name "$dirname"_week.tex if don't already yet
if [ -d "$dirname" ]; then
    echo "A directory called $dirname already exists in the directory $year.
            No additional entry."
    exit
fi

echo New directory $dirname created
mkdir $dirname
cd $dirname # $_ is a special variables set to final argument of last command executed

#Add a new file with name "$week"_main.tex if don't exist yet
if [ -f "$filename" ]; then
    echo "A file called '$filename' already exists in diretory $year. Aborting addition of new entry."
    exit
fi

#Copy in new directory diary pages
cp ../../src/main.tex $filename
cp ../../src/beg_report.tex "$week"_beg_report.tex
cp ../../src/mid_report.tex "$week"_mid_report.tex
cp ../../src/end_report.tex "$week"_end_report.tex

#Inside $filename replace
#@year -> $year
#@MONTH -> date +%B 
#@dday -> day
#@day -> date +%e
##NUM -> $week
sed -i "s/@year/$year/g" $filename
sed -i "s/@MONTH/`date +%B`/g" $filename
sed -i "s/@dday/$day/g" $filename
sed -i "s/@day/`date +%e`/g" $filename
sed -i "s/@NUM/$week/g" $filename

echo "Finished adding $filename to $year."
