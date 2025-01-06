#!/bin/sh

year=$(date +%G)
month=$(date +%m)
day=$(date +%d)
week=$(date +%W)
weekNoPad=$(date +%-W)
monthname=$(date +%B)
LWD="/home/tommaso/Documents/Uni/Library/My_notes/research-diary-project-template"

echo "Today is $year / $month / $day"

if [ ! -d "$year" ]; then
    mkdir $year
    mkdir $year/images
    cd $year
#   ln -s ../images/university_logo.eps .
#   ln -s ../images/university_logo.png .
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
monthdirname="$monthname"
dirname="$week"_week


#Add a new directory with name "$monthname$ if don't exist yet

if [ -d "$monthdirname" ]; then
    echo "A directory called $monthdirname already exists in the directory $year.
            No additional entry."
    exit
fi

echo New directory $monthdirname created
mkdir $monthdirname
cd $monthdirname

#Add a new directory with name "$dirname" if don't exist yet
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
cp $LWD/src/main.tex $filename
cp $LWD/src/beg_report.tex "$week"_beg_report.tex
cp $LWD/src/mid_report.tex "$week"_mid_report.tex
cp $LWD/src/end_report.tex "$week"_end_report.tex

#Inside $filename replace
#@year -> $year
#@MONTH -> date +%B 
#@dday -> day
#@day -> date +%e
##NUM -> $week number
sed -i "s/@year/$year/g" $filename
sed -i "s/@MONTH/`date +%B`/g" $filename
sed -i "s/@dday/$day/g" $filename
sed -i "s/@day/`date +%e`/g" $filename
sed -i "s/@NUM/$week/g" $filename

#Inside "$week"_beg_report.tex replace @MONTHNAME and @NUM
sed -i "s/@MONTHNAME/$monthname/g" "$week"_beg_report.tex
if [ $week -lt 10 ]; then #if $week<=10, remove padded field with 0
sed -i "s/@NUM/$weekNoPad/g" "$week"_beg_report.tex
else #else do nothing
sed -i "s/@NUM/$week/g" "$week"_beg_report.tex
fi

echo "Finished adding $filename to $year."
