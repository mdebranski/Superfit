# nuke out the existing compiled assets
rm -fr ./build/*

# set required environment variables
# REDISCLOUD_URL
#export REDISCLOUD_URL="localhost"

# compile the assets
RAILS_ENV=production bundle exec rake assets:precompile

# move the compiled assets to the build folder
mv ./public/assets/ ./build

# move cordova.js file to 'phonegap.js'
mv ./build/assets/cordova.js ./build/phonegap.js

# nuke out the gzipped files
rm ./build/assets/*.gz

# copy wods over
cp ./public/wods.txt ./build/
cp ./public/wods_version.txt ./build/

# copy superfit.html over as index.html
cp ./public/superfit.html ./build/index.html
