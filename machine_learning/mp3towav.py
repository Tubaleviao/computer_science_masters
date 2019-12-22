# convert wav to mp3

from pydub import AudioSegment
from glob import glob

# files                                                                         
train_musics = glob("test/*.mp3")

for file in train_musics:
    f = file.split("/")[-1]
    sound = AudioSegment.from_mp3(file)
    sound.export(f.split(".")[0]+".wav", format="wav")
