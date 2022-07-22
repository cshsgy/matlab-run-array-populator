rm -f *.zip
module load matlab/r2020b
matlab -nodisplay -r "batch_processing; exit;"
zip -q output_figures.zip *.png
rm -f *.png
