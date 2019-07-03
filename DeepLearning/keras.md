mkvirtualenv -p python2.7 keras_tf1.1_cp27
export TF_BINARY_URL=https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.1.0rc2-cp27-none-linux_x86_64.whl
pip install --upgrade $TF_BINARY_URL
pip install numpy scipy scikit-learn pillow h5py keras ipython ipykernel seaborn

python -m ipykernel install --user --name=keras_tf1.1_cp27
deactivate 
service jupyter restart
sudo systemctl restart jupyter.service
sudo systemctl status jupyter.service