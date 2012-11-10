"""
pingprocessor.py

Takes as an input a song; outputs an initial game state for Ping game and chopped up sound clips.

By Jim Fingal 2012-11-10
"""
import sys

import echonest.audio as audio
import string

usage = """
Usage: 
    python pingprocessor.py <segments|tatums|beats|bars|sections> <inputfilename> <outputfilenamebase>

Example:
    python pingprocessor.py beats Heresy.mp3 Heresy
    
"""

def main(input_filename, output_filename):
    
    sounds = []
    bricks = []
    
    audiofile = audio.LocalAudioFile(input_filename)   
    bars = audiofile.analysis.bars
   
    counter = 0
    
    for bar in bars:
        counter += 1
                
        collect = audio.AudioQuantumList()
        collect.append(bar)
        
        out = audio.getpieces(audiofile, collect)        
        this_filename = "%s%d.mp3" % (output_filename, counter)
        
        sounds.append("%s" % this_filename)
        # out.encode(this_filename)
        
        if counter == 20:
            break
        
    luacode_output(output_filename, sounds)
    
        
    
    """
    loudness_min = float(1000000)
    loudness_average = float(0)
    loudness_max = float(-100)
    
    duration_min = float(10000000)
    duration_max = float(-100)
    duration_average = float(0)
    
    for segment in segments:
        counter += 1
        
        loudness_average += segment.loudness_max
        
        if segment.loudness_max < loudness_min:
            loudness_min = segment.loudness_max
        
        if segment.loudness_max > loudness_max:
            loudness_max = segment.loudness_max
        
        duration_average += segment.duration
        
        if segment.duration < duration_min and segment.duration > 0:
            duration_min = segment.duration
        
        if segment.duration > duration_max:
            duration_max = segment.duration
            
            
    loudness_average = loudness_average / counter
    duration_average = duration_average / counter
    
    print "Max Duration: %d" % duration_max
    print "Min Duration: %d" % duration_min
    print "Ave Duration: %d" % duration_average
    print "Max Loudness: %d" % loudness_max
    print "Min Loudness: %d" % loudness_min
    print "Ave Loudness: %d" % loudness_average
    """


def configoutput(output_filename, sounds):
    f = open("%s.ping" % output_filename, 'w')
    
    for sound in sounds:
        f.write("sound")
    

def luacode_output(output_filename, sounds):
    f = open("%s.ping" % output_filename, 'w')
    
    for sound in sounds:
        f.write("brick_%s = love.audio.newSource('%s', 'static')\n" % (sound.split(".")[0], sound))
    
    row = 0
    col = 0
    f.write("return { \n")
    for sound in sounds:
        f.write("{ exists = true, x = %d, y = %d, width = 100, height = 20, snd = brick_%s },\n" % (col * 200, row * 20, sound.split(".")[0]))
        
        col += 1
        if col >= 4:
            col=0
            row +=1
        
    f.write(" }\n")
    

def dump(obj):
    for attr in dir(obj):
        print "obj.%s = %s" % (attr, getattr(obj, attr))

if __name__ == '__main__':
    try:
        input_filename = sys.argv[1]
        output_filename = sys.argv[2]
     
    except:
        print usage
        sys.exit(-1)
   
    main(input_filename, output_filename)
