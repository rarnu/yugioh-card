#!/bin/sh

JRE_HOME=${JAVA_HOME}/jre
CLASSPATH=.:${JAVA_HOME}/lib/dt.jar:${JAVA_HOME}/lib/tools.jar

export JRE_HOME=${JRE_HOME}
export CLASSPATH=${CLASSPATH}
export LD_LIBRARY_PATH=.:${LD_LIBRARY_PATH}

cd com/rarnu/yugioh
rm *.class
javac *.java
cd ../../../
 
java com/rarnu/yugioh/Main






