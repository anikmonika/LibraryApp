DIR="$(cd "$(dirname "$0")" && pwd)"
WRAPPER_JAR="$DIR/gradle/wrapper/gradle-wrapper.jar"

if [ ! -f "$WRAPPER_JAR" ]; then
  echo "Missing gradle-wrapper.jar at $WRAPPER_JAR"
  echo "If you cloned this repo without Git LFS or wrapper jar, re-generate wrapper:"
  echo "  gradle wrapper"
  exit 1
fi

JAVA_EXEC="${JAVA_HOME:+$JAVA_HOME/bin/}java"

exec "$JAVA_EXEC" -classpath "$WRAPPER_JAR" org.gradle.wrapper.GradleWrapperMain "$@"
