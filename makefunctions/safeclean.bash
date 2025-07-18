if [ -z "$BUILD_DIR" ] || [ "$BUILD_DIR" = "/" ] || [ "$BUILD_DIR" = "$HOME" ]; then
    echo "Dangerous or empty BUILD_DIR detected. Exiting..."
    exit 1
fi

echo "Contents of ${BUILD_DIR}:"
ls -al ${BUILD_DIR}

read -p "Is --$BUILD_DIR-- the correct path? (y/n): " correct_path
if [ "${correct_path}" = "y" ]; then
	echo "Proceeding..."
	rm -r ${BUILD_DIR}/*
	echo "Build Files Removed. Exiting..."
	exit 0 #success
fi

echo "Exiting..."
exit 1 #insuccesful