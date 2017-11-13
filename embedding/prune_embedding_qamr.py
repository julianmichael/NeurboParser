# -*- coding: utf-8 -*-
"""
Created on Sat Nov  5 20:44:45 2016

@author: hpeng
"""
import io
UNK = '__UNK__'
# paths is a list of file paths as strings
def build_vocab(paths):
    word2idx = {}; n = 0
    for path in paths:
        with io.open(path, 'r', encoding = 'utf_8') as fin:
            for line in fin:
                ws = line.strip().split('\t')
                if len(ws) <= 1:
                    continue
                word = ws[1].lower()
                if word not in word2idx:
                    word2idx[word] = n
                    n += 1
    return word2idx

def prune_embedding(infile = '.', word2idx = None):
    path = '%s/glove.6B.100d.txt' % infile
    fout = io.open('%s/glove.100.qamr.pruned' % infile, 'w', encoding = 'utf-8')
    n = 0
    with io.open(path, 'r', encoding = 'utf-8') as fin:
        for line in fin:
            ws = line.strip().split()
            if len(ws) <= 5:
                continue
            word = ws[0]
            if word.lower() not in word2idx:
                continue
            ws[0] = ws[0].lower()
            o_line = ' '.join(ws)
            fout.write(o_line + u'\n')
            n += 1
    print 'Number of embeddings in vocabulary: %d' % n
    fout.close()

if __name__ == '__main__':
    base_dir = '../qamr_data/'
    files = ['train.sdp', 'dev.sdp', 'test.sdp']
    paths = [ '%s/%s' % (base_dir, filepath) for filepath in files]
    word2idx = build_vocab(paths)
    prune_embedding(infile = '.', word2idx = word2idx)