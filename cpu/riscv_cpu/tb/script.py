'''
@Author: JiangChen
Get filename list from specified directory
'''
import argparse
import os

parser = argparse.ArgumentParser(description='Get Filenames')
parser.add_argument('--path', '-p', type=str, default='./RISCV_I', help='root directory to get files')
parser.add_argument('--suffix', '-s', type=str, default=None, help='suffix for all the goal files')
parser.add_argument('--save_path', '-sp', type=str, default='.', help='save path for the generated txt')

args = parser.parse_args()
path = args.path
suffix = args.suffix
save_path = args.save_path
goal = path.split('_')[-1]

if __name__ == '__main__':
    func_t = lambda x: x if x is not None else 'any'
    with open(f'{save_path}/filenames_for_{goal}_inst_with_type_{func_t(suffix)}.txt', 'w') as file:
        for file_name in os.listdir(path):
            if os.path.isfile(f'{path}/{file_name}'):
                if suffix is not None and file_name.split('.')[-1] == suffix:
                    file.write(file_name + '\n')
                elif suffix is None and file_name.split('.')[-1] == file_name:
                    file.write(file_name + '\n')
