#!/usr/bin/env python3

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

''' Generates examples from kitchen-terraform test cases '''

import glob
import os
from shutil import (
  copyfile,
  rmtree
)

BASE_DIR = "test/fixtures"
TARGET_DIR = "./examples"
EXCLUDED_DIRECTORIES = [
    "terraform.tfstate.d",
    ".terraform",
]
EXCLUDED_FILES = [
  "config.sh",
  "sample.sh",
]

if os.path.isdir(TARGET_DIR):
    rmtree(TARGET_DIR)

fixtures_folders = glob.glob(BASE_DIR + "/*")
for folder in fixtures_folders:
    if os.path.isdir(folder):
        case_name = folder.replace(BASE_DIR + "/", "")
        example_directory = TARGET_DIR + "/" + case_name
        os.makedirs(example_directory)

        for root, dirnames, filenames in os.walk(folder):
            full_paths = [(file, root + "/" + file) for file in filenames]
            for path in full_paths:
                excluded = False
                for excluded_directory in EXCLUDED_DIRECTORIES:
                    if "/" + excluded_directory + "/" in path[1]:
                        excluded = True
                if path[0] in EXCLUDED_FILES:
                    excluded = True
                if not excluded:
                    additional_folder = path[1].replace(
                        folder,
                        ""
                    ).replace(
                        path[0],
                        ""
                    )
                    subdir = example_directory + additional_folder
                    if not os.path.isdir(subdir):
                        os.makedirs(subdir)
                    copyfile(path[1], subdir + path[0])
