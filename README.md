# GANSpace: Discovering Interpretable GAN Controls
![Python 3.7](https://img.shields.io/badge/python-3.7-green.svg)
![PyTorch 1.3](https://img.shields.io/badge/pytorch-1.3-green.svg)
[![Open In Colab ganspace](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1-pO_XP9YhI4XIHQ6kUh-xMGoPJSAhjn5?usp=sharing)
[![Open In Colab experiments](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/1qTyTMgeSQLpqyVSkws1fCtVlkL1vFZDj?usp=sharing)

If Colab notebook doesn't work, copy this link: https://colab.research.google.com/drive/1-pO_XP9YhI4XIHQ6kUh-xMGoPJSAhjn5?usp=sharing

Exploring latent space direction for image synthesis networks has been a rather hard and heavilysupervised-focused task, though essential in order to perform interesting local and global edits in thelow-dimensional latent space, which translate in meaningful manipulations in the image space. Sincethe proposal of using dimensionality reduction techniques to discover interpretable latent direction,the focus has shifted towards exploring the capabilities and the alternatives of this approach. In thiswork, we are using the latent space dimensionality reduction setting to apply dimensionality reductiontechniques not explored in previous literature.  Additionally, we apply the various dimensionalityreduction techniques on a state-of-the-art image synthesis model, named StyleGAN2-ADA, which iscapable of generating high-resolution images while trained on limited input data. The discovery ofinterpretable directions on this novel architecture can reveal useful insights regarding controllableimage manipulations, inspiring future works on custom-made datasets with fewer training examples.The overall setting does not require any kind of re-training, which eliminates the computationalresources needed and enables the usage of this technique on behalf of any institution or individual.

> **GANSpace: Discovering Interpretable GAN Controls**<br>

## Setup
See the [setup instructions](SETUP.md).

## Usage
This repository includes versions of BigGAN, StyleGAN, and StyleGAN2 modified to support per-layer latent vectors.

# Experiments

**Interactive model exploration**
```
# Explore BigGAN-deep husky
python interactive.py --model=BigGAN-512 --class=husky --layer=generator.gen_z -n=1_000_000

# Explore StyleGAN2 ffhq in W space
python interactive.py --model=StyleGAN2 --class=ffhq --layer=style --use_w -n=1_000_000 -b=10_000

# Explore StyleGAN2 cars in Z space
python interactive.py --model=StyleGAN2 --class=car --layer=style -n=1_000_000 -b=10_000
```
```
# Apply previously saved edits interactively
python interactive.py --model=StyleGAN2 --class=ffhq --layer=style --use_w --inputs=out/directions
```

**Visualize principal components**
```
# Visualize StyleGAN2 ffhq W principal components
python visualize.py --model=StyleGAN2 --class=ffhq --use_w --layer=style -b=10_000

# Create videos of StyleGAN wikiart components (saved to ./out)
python visualize.py --model=StyleGAN --class=wikiart --use_w --layer=g_mapping -b=10_000 --batch --video
```

**Options**
```
Command line paramaters:
  --model      one of [ProGAN, BigGAN-512, BigGAN-256, BigGAN-128, StyleGAN, StyleGAN2]
  --class      class name; leave empty to list options
  --layer      layer at which to perform PCA; leave empty to list options
  --use_w      treat W as the main latent space (StyleGAN / StyleGAN2)
  --inputs     load previously exported edits from directory
  --sigma      number of stdevs to use in visualize.py
  -n           number of PCA samples
  -b           override automatic minibatch size detection
  -c           number of components to keep
```

## Reproducibility
All figures presented in the main paper can be recreated using the included Jupyter notebooks:
* Figure 1: `figure_teaser.ipynb`
* Figure 2: `figure_pca_illustration.ipynb`
* Figure 3: `figure_pca_cleanup.ipynb`
* Figure 4: `figure_style_content_sep.ipynb`
* Figure 5: `figure_supervised_comp.ipynb`
* Figure 6: `figure_biggan_style_resampling.ipynb`
* Figure 7: `figure_edit_zoo.ipynb`

## Known issues
* The interactive viewer sometimes freezes on startup on Ubuntu 18.04. The freeze is resolved by clicking on the terminal window and pressing the control key. Any insight into the issue would be greatly appreciated!

## Integrating a new model
1. Create a wrapper for the model in `models/wrappers.py` using the `BaseModel` interface.
2. Add the model to `get_model()` in `models/wrappers.py`.

## Importing StyleGAN checkpoints from TensorFlow
It is possible to import trained StyleGAN and StyleGAN2 weights from TensorFlow into GANSpace.

### StyleGAN
1. Install TensorFlow: `conda install tensorflow-gpu=1.*`.
2. Modify methods `__init__()`, `load_model()` in `models/wrappers.py` under class StyleGAN.

### StyleGAN2
1. Follow the instructions in [models/stylegan2/stylegan2-pytorch/README.md](https://github.com/harskish/stylegan2-pytorch/blob/master/README.md#convert-weight-from-official-checkpoints). Make sure to use the fork in this specific folder when converting the weights for compatibility reasons.
2. Save the converted checkpoint as `checkpoints/stylegan2/<dataset>_<resolution>.pt`.
3. Modify methods `__init__()`, `download_checkpoint()` in `models/wrappers.py` under class StyleGAN2.

## Acknowledgements
We would like to thank:

* The authors of the PyTorch implementations of [BigGAN][biggan_pytorch], [StyleGAN][stylegan_pytorch], and [StyleGAN2][stylegan2_pytorch]:<br>Thomas Wolf, Piotr Bialecki, Thomas Viehmann, and Kim Seonghyeon.
* Joel Simon from ArtBreeder for providing us with the landscape model for StyleGAN.<br>(unfortunately we cannot distribute this model)
* David Bau and colleagues for the excellent [GAN Dissection][gandissect] project.
* Justin Pinkney for the [Awesome Pretrained StyleGAN][pretrained_stylegan] collection.
* Tuomas Kynkäänniemi for giving us a helping hand with the experiments.
* The Aalto Science-IT project for providing computational resources for this project.

## Citation
```
@inproceedings{härkönen2020ganspace,
  title     = {GANSpace: Discovering Interpretable GAN Controls},
  author    = {Erik Härkönen and Aaron Hertzmann and Jaakko Lehtinen and Sylvain Paris},
  booktitle = {Proc. NeurIPS},
  year      = {2020}
}
```

## License

The code of this repository is released under the [Apache 2.0](LICENSE) license.<br>
The directory `netdissect` is a derivative of the [GAN Dissection][gandissect] project, and is provided under the MIT license.<br>
The directories `models/biggan` and `models/stylegan2` are provided under the MIT license.


[biggan_pytorch]: https://github.com/huggingface/pytorch-pretrained-BigGAN
[stylegan_pytorch]: https://github.com/lernapparat/lernapparat/blob/master/style_gan/pytorch_style_gan.ipynb
[stylegan2_pytorch]: https://github.com/rosinality/stylegan2-pytorch
[stylegan2_ADA_pytorch]: https://github.com/NVlabs/stylegan2-ada
[gandissect]: https://github.com/CSAILVision/GANDissect
[pretrained_stylegan]: https://github.com/justinpinkney/awesome-pretrained-stylegan
