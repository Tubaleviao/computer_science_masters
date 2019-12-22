# takes arouns 2 hours to run on google cloud plataform
# in a 6 cores vCPU, 32GB RAM machine

import librosa
import numpy as np
import soundfile as sf
from glob import glob
import pickle
import time
from datetime import datetime
from sklearn.neural_network import MLPRegressor

start_time = time.time()

mlp = MLPRegressor(hidden_layer_sizes=(1000,1000,), activation='logistic', 
		learning_rate_init=0.001, max_iter=1000)

a = np.array([])
b = np.array([])

def save_model(mlp):
	now = datetime.now()
	filename = now.strftime("%Y%m%d%H%M%S") + '.model'
	pickle.dump(mlp, open(filename, 'wb'))
	#model = pickle.load( open( "something.model", "rb" ) )

def fitSongs(novoice, voice, z1, z0):
	print("loading song "+voice.split("_")[0].split("/")[1]+"...")
	audio0, sample_rate0 = librosa.load(novoice) 
	spectrum0 = librosa.stft(audio0)
	audio1, sample_rate1 = librosa.load(voice) 
	spectrum1 = librosa.stft(audio1)

	# use 'a.T.view(...).T' instead
	spec0f = spectrum0.T.view(np.float32).T
	spec1f = spectrum1.T.view(np.float32).T

	spec1f = spec1f.T
	spec0f = spec0f.T
	print("training shape: "+str(spec0f.shape))

	a = np.append(z1, spec1f).reshape(len(z1)+len(spec1f),len(spec1f[0]))
	b = np.append(z0, spec0f).reshape(len(z0)+len(spec0f),len(spec0f[0]))
	return [a, b]

files = glob("train/*.*")
print(str(len(files)/2)+" musics")
for i in range(len(files)):
	if (i % 2) != 0:
		x = "train/"+str(int((i+1)/2))+"_0.wav"
		y = "train/"+str(int((i+1)/2))+"_1.wav"
		t = fitSongs(x, y, a, b)
		a = t[0]
		b = t[1]

print(a.shape)
mlp.fit(a, b)

save_model(mlp)

a3, s3 = librosa.load("test/prototype.wav") 
spectrum3 = librosa.stft(a3)
spec3f = spectrum3.T.view(np.float32).T # spectrum3.T.view(np.float64).T

# size 747 is different from 634
spec3f = spec3f.T
print("prediction shape: "+str(spec3f.shape))
spec_resf = mlp.predict(spec3f)

new_stuff = []
for j in range(len(spec_resf)):
    for i in range(len(spec_resf[j])):
        if(i%2!=0):
            new_stuff.append(np.complex(spec_resf[j][i-1], spec_resf[j][i]))
            
spec_resfn = np.array(new_stuff).reshape(spectrum3.T.shape)

fff = np.complex64(spec_resfn).T
reconstructed_audio = librosa.istft(fff)
sf.write("test/prototype_result.wav", reconstructed_audio, s3)

print("--- %s seconds ---" % (time.time() - start_time))
