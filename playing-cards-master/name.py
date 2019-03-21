import os
import shutil
src = "/Users/waddahaldrobi/Desktop/playing-card-detection-master/data/playing_cards_dataset"
src_files = os.listdir(src)
dest = "/Users/waddahaldrobi/Desktop/playing-card-detection-master/data/cards/"

for file_name in src_files:
    full_file_name = os.path.join(src, file_name)
    if (os.path.isfile(full_file_name)):
        dest2 = dest+file_name[:2]
        shutil.copy(full_file_name, dest2)
