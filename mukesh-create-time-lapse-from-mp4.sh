#! /bin/bash

concat_output=ffmpeg-concatenated.mp4
output=final.mp4
list=videos.txt

# remove any prior file input for ffmpeg
rm $list
rm $concat_output
rm $output

# create input file for ffmpeg
for f in *.mp4
do
	echo "file '$f'" >> $list
done

ffmpeg -hwaccel cuda -hwaccel_output_format cuda -f concat -i $list -c copy $concat_output

read -p "Enter framestep for the video [5]: " framestep
framestep=${framestep:-5}

read -p "Enter FPS for the video [120]: " fps
fps=${fps:-120}

bitrate=`mediainfo --Output='Video;%BitRate%' $concat_output`


echo "ffmpeg -hwaccel cuda -hwaccel_output_format cuda -an -i $concat_output -vf framestep=$framestep,setpts=N/$fps/TB -r $fps -c:v h264_nvenc -b:v $bitrate $output"

read -p "Proceed??"

#ffmpeg -an -i $concat_output -vf framestep=$framestep,setpts=N/$fps/TB -r $fps $output
ffmpeg -hwaccel cuda -hwaccel_output_format cuda -an -i $concat_output -vf framestep=$framestep,setpts=N/$fps/TB -r $fps -c:v h264_nvenc -b:v $bitrate $output

mediainfo $output
