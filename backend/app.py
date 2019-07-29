from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from image_reco_script import *
from flask import Flask, render_template, redirect, url_for, flash, request, jsonify, session

import argparse

import numpy as np
import tensorflow as tf
import os
from symspellpy.symspellpy import SymSpell  # import the module
from symspellpy.symspellpy import SymSpell, Verbosity
import pandas
import pickle
from itertools import chain
from nltk.tokenize import TweetTokenizer
#import pandas
import re
from nltk.stem import WordNetLemmatizer
import nltk
from gevent.pywsgi import WSGIServer
from gevent import monkey
from werkzeug.debug import DebuggedApplication
import queue
from flask_cors import CORS
from sqlalchemy import *
import sqlalchemy as sa
from sqlalchemy.orm import sessionmaker
from werkzeug.security import generate_password_hash, check_password_hash
import sys
from werkzeug.utils import secure_filename
import argparse
import numpy as np
import tensorflow as tf

ALLOWED_EXTENSIONS = set(['txt', 'pdf', 'png', 'jpg', 'jpeg', 'gif'])

basedir = os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0,basedir)
q = queue.LifoQueue()
engine = sa.create_engine("sqlite:///" + os.path.join(basedir,'database.db'))

UPLOAD_FOLDER = '/home/rishimahadevan/flask_api/uploads'
print(UPLOAD_FOLDER)
# need to patch sockets to make requests async
# you may also need to call this before importing other packages that setup ssl
monkey.patch_all()

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
CORS(app)
lemmatizer = WordNetLemmatizer()
tknzr = TweetTokenizer()
#nltk.download('wordnet')
from nltk.corpus import stopwords
PIK = "pickle.dat"
PIK_1 = "pickle_1.dat"
PIK_2 = "pickle_2.dat"
PIK_3 = "pickle_3.dat"
PIK_4 = "pickle_4.dat"
model_file = "output_graph.pb"
label_file = "output_labels.txt"
graph = load_graph(model_file)

input_layer = "Placeholder"
output_layer = "final_result"
input_name = "import/" + input_layer
output_name = "import/" + output_layer
input_operation = graph.get_operation_by_name(input_name)
output_operation = graph.get_operation_by_name(output_name)

def allowed_file(filename):
        return '.' in filename and \
                           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS
with open(PIK, "rb") as f:
    dict_1 = pickle.load(f)
# maximum edit distance per dictionary precalculation
max_edit_distance_dictionary = 3
prefix_length = 9
# create object
with open(PIK_2,"rb") as f:
    dict_2 = pickle.load(f)

with open(PIK_1, "rb") as f:
    sym_spell = pickle.load(f)
with open(PIK_3, "rb") as f:
    sym_spell_1 = pickle.load(f)

with open(PIK_4, "rb") as f:
    dict_no_need = pickle.load(f)
print("done")
def main1(string_t):
    #string_t = "i have seizures. I am ashthma attack. Yellow phlegm. "
    string_t_1 = string_t.split(".")
    for string_t in string_t_1:
        max_edit_distance_lookup = 3
        max_edit_distance_lookup_1 = 2
        tokenized_words = tknzr.tokenize(string_t.lower())
        stop_words = stopwords.words('english')
        lst = ["keep","make","feel","feels","i'hv","i've","fort","free","information","other","may","having","what","which","out","contact","business","pm","view","state","good","name","some","yours","really","especially"]
        for t in lst:
            stop_words.append(t)
        #print(stop_words)
        word_list = [word for word in tokenized_words if word not in stop_words]
        print(word_list)
        #print(word_list)
        i = 0
        word_list_1 = []
        for word in word_list:
            tog = 0
            if(word == lemmatizer.lemmatize(word)):
                word = lemmatizer.lemmatize(word,'v')
            else:
                word = lemmatizer.lemmatize(word)
            if(word in dict_no_need):
                if(dict_no_need[word] >= 1500):
                    #print("wword found", word)
                    tog = 1
            if(tog == 0):
                word = word.replace("ing","")
                word_list_1.append(word)
                word_list[i] = word
                i+=1
        word_list = word_list_1
        #print(word_list)
        input_term  = " ".join(word_list)

        #input_term = = ("hearr pein")
        print(input_term)
        suggestions = sym_spell.lookup_compound(input_term,max_edit_distance_lookup)
        suggestions_1  = sym_spell_1.lookup_compound(input_term,max_edit_distance_lookup_1)
        #print(suggestions[0].term)
        #print("sSSSSSSSSS",suggestions[0])

        if(len(suggestions_1) > 0):
            temp_str_1 = suggestions_1[0].term
        #print( temp_str_1)
        temp_str_1 = temp_str_1.split(" ")
        #print(suggestions[0])
        if(len(suggestions)>0):
            temp_str = suggestions[0].term

        temp_str = temp_str.split(" ")
        i = 0
        result = []
        #print(temp_str)
        #print(dict_1["asthma_attack"])
        while(i< len(temp_str)-1):
            text = temp_str[i] + " "+ temp_str[i+1]
            if(text.lower() in dict_1):
                temp_str_1[i] = "X"
                try:
                    temp_str_1[i+1] = "X"
                except:
                    pass
                result.append([dict_1[text.lower()],text])
                #print(dict_1[text.lower()],"predicted from:", text)
            i+=1
        i = 0

        while(i< len(temp_str_1)):
            if(temp_str_1[i].lower() in dict_2):
                result.append([dict_2[temp_str_1[i].lower()],temp_str_1[i]])
                #print(dict_2[temp_str_1[i].lower()],"one word predicted from:",temp_str_1[i])
            i+=1
        return result
            #for suggestion in suggesoutput_nametions:
        #print(suggestion.term)

@app.route('/')
def index():
    return "OK"
@app.route("/image_upload") 
def image_upload(): 
    return render_template("image_upload.html") 

@app.route('/login', methods=["POST","GET"])
def login():
    if(request.method == 'POST'):
        result = request.form
        password = result["password"]
        email = result["username"]
        print("login 1",password)
        hashed_password = generate_password_hash(password,method='sha256')
        #sql = "delete  from user"
        #engine.execute(sql)
        #sql = "insert into user (email,password) VALUES ('%s','%s')"%(email,hashed_password)
        #engine.execute(sql)

        sql = "select password from" + ' "user" ' + "where email = '%s'"%(email)
        res = engine.execute(sql).fetchone()

        #print(res[0])
        if(res is not None):
            if(check_password_hash(res[0],password)):
                return "True"+" "+email
            return "False"+" "+"no_email"
        else:
            return "False"+" "+"no_email" 
def get_medicine_name(filename):
    input_height = 299
    input_width = 299
    input_mean = 0
    input_std = 255
    input_layer = "input"
    model_file = "output_graph.pb"
    label_file = "output_labels.txt"
    t = read_tensor_from_image_file(
        filename,
        input_height=input_height,
        input_width=input_width,
        input_mean=input_mean,
        input_std=input_std)
    with tf.Session(graph=graph) as sess:
      results = sess.run(output_operation.outputs[0], {
          input_operation.outputs[0]: t
      })
    results = np.squeeze(results)
    top_k = results.argsort()[-5:][::-1]
    labels = load_labels(label_file)
    j =0
    for i in top_k:
      if(j == 0):
          return str(labels[i])
      #print(labels[i], results[i])


@app.route('/image_reco',methods = ['POST','GET'])
def image_reco():
    if(request.method == 'POST'):
        file = request.files["file"]
        if(file and allowed_file(file.filename)):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config['UPLOAD_FOLDER'],filename))
            filename1 = os.path.join(app.config['UPLOAD_FOLDER'],filename)
            med_name = get_medicine_name(filename1)
            sql = "select number_of_times,dosage from medicine where name = '%s' and email = '%s'" %(med_name,'hotspur1997@gmail.com') 
            res = engine.execute(sql).fetchone() 
            if(res is not None): 
                return "it is "+ med_name +". Doctor has prescribed a dosage of " + str(res[1]) + " " + str(res[0])+ " times a day" 
            else: 
                return medicine_name + " it is not prescribed by the doctor" 



@app.route('/dashboard')
def dashboard():
    return render_template('index1.html')
@app.route('/data_show',methods=['POST','GET'])
def data_show():
    print("adsasad")
    if(not q.empty()):
        return jsonify(data_show = q.get())
    else:
        return jsonify(data_show = "no")
@app.route('/get_data',methods = ['POST','GET'])
def get_data():
    if (request.method == 'POST'):
        print("recieved",request.form)
        result = request.form
        name = result["text"]
        print("got " ,name)
        name = name.replace("!",".")
        name = name.replace("?",".")
        name = name.replace(",", "")
        name = name.replace(";","")
        name = name.split(".")
        result1 = []
        print(name)
        for sentence in name:
            print("sending ", sentence)
            result = main1(sentence)
            #return result
            print("result is ", result)
            #print("Symptoms are: ")
            for t in result:
                if(len(t)>0):
                    result1.append(t[0])
        q.put(result1)
        return jsonify(symptoms = result1)

        #return "hello"
    else:
        return ("please post!")
@app.route('/send_medicine',methods = ['POST','GET'])
def send_medicine(): 
    if(request.method == 'POST'): 
        result = request.form 
        number_medicine = result["number_med"]  
        email_address = result["email"] 
        i = 0 
        while(i<int(number_medicine)): 
            medicine = "medicine_name"+str(i)
            medicine = result[medicine] 
            dosage = "dosage"+str(i) 
            dosage = result[dosage] 
            number_of_times = "number_of_times"+str(i)
            number_of_times = result[number_of_times]
            sql = "insert into medicine (name,dosage,email,number_of_times) VALUES ('%s','%s','%s','%s')" %(medicine,dosage,email_address,number_of_times) 
            engine.execute(sql) 
            i+=1 
    return "ok"; 
@app.route('/get_medicine_list',methods = ['POST','GET'] )
def get_medicine_list(): 
    if(request.method == 'POST'): 
        result = request.form 
        email = result["email"] 
        sql = "select name,dosage,number_of_times  from medicine where email = '%s'"%(email) 
        res = engine.execute(sql).fetchall() 
        str_1 = ""
        j = 0 
        for t in res:
            str_temp = t[0].capitalize()+";"+t[1]+";"+t[2] +" times a day"
            if(j!= len(res)-1): 
                str_temp+=","
            str_1 += str_temp 
            j +=1 
        return str_1 




def main():
    # use gevent WSGI server instead of the Flask
    # instead of 5000, you can define whatever port you want.
    http = WSGIServer(('0.0.0.0', 5001),app.wsgi_app)
    http.serve_forever()

if __name__ == "__main__":
    #port = int(os.environ.get("PORT", 5000))
    #app.run(host='0.0.0.0', port=port,debug = True)
    main()
