from pydub import AudioSegment
from glob import glob

gac = glob("instruments/more/gac/*.*")
gel = glob("instruments/more/gel/*.*")
org = glob("instruments/more/org/*.*")

total = gel + gac + org

for f in range(132, len(total)+132):
    sound1 = AudioSegment.from_file("aud3s.wav")
    sound2 = AudioSegment.from_file(total[f-132])
    combined = sound1.overlay(sound2)
    sound2.export("train2/"+str(f+132)+"_0.wav", format='wav')
    combined.export("train2/"+str(f+132)+"_1.wav", format='wav')
    
