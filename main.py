from vosk import Model, KaldiRecognizer
import json
import wave
import re
import tkinter
from tkinter import ttk
from tkinter import filedialog
import tkinter.messagebox as mb


def open_and_transcript():
    filepath = filedialog.askopenfilename()
    wavfile = filepath
    workdir = "C://Users/kolod/Downloads/vosk-model-small-ru-0.22/vosk-model-small-ru-0.22"
    model = Model(workdir)

    wf = wave.open(wavfile, "rb")
    rcgn_fr = wf.getframerate() * wf.getnchannels()
    rec = KaldiRecognizer(model, rcgn_fr)
    result = ''
    last_n = False
    read_block_size = wf.getnframes()
    while True:
        data = wf.readframes(read_block_size)
        if len(data) == 0:
            break

        if rec.AcceptWaveform(data):
            res = json.loads(rec.Result())

            if res['text'] != '':
                result += f" {res['text']}"
                if read_block_size < 200000:
                    print(res['text'] + " \n")

                last_n = False
            elif not last_n:
                result += '\n'
                last_n = True
    res = json.loads(rec.FinalResult())
    result += f" {res['text']}"
    text = '\n'.join(line.strip() for line in re.findall(r'.{1,150}(?:\s+|$)', result))
    msg = "Data compiled, now choose a savefile"
    mb.showinfo("Info", msg)
    filepath = filedialog.askopenfilename()
    f = open(filepath, 'w')
    f.write(text)
    f.close()
    msg = "Text saved"
    mb.showinfo("Info", msg)


root = tkinter.Tk()
root.title("Transcript")
root.geometry("300x300")
root.configure()
btn = ttk.Button(root, text="Choose file", command=lambda:open_and_transcript())
btn.pack(expand = True)
root.mainloop()
