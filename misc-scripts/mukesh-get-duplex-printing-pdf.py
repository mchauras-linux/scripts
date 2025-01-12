#!/usr/bin/python3

import sys
import os
from PyPDF2 import PdfReader, PdfWriter

def get_duplex_printing_pdf(path, dest_dir):
    # file name with extension
    file_name = os.path.basename(path)
    
    # file name without extension
    file_name = os.path.splitext(file_name)[0]

    f = open(path, 'rb')
    pdf = PdfReader(f)
    no_pages = len(pdf.pages)
    pdf_writer_front = PdfWriter()
    pdf_writer_back = PdfWriter()
    
    for i, p in enumerate(pdf.pages):
        if i % 2 == 0:
            pdf_writer_front.add_page(p)
        else:
            pdf_writer_back.add_page(p)

    outputf = f'{dest_dir}/{file_name}_front.pdf'
    outputb = f'{dest_dir}/{file_name}_back.pdf'
    with open(outputf, 'wb') as output_pdf:
        pdf_writer_front.write(output_pdf)
    if no_pages % 2 != 0 and no_pages > 1:
        pdf_writer_back.add_blank_page()
    with open(outputb, 'wb') as output_pdf:
        pdf_writer_back.write(output_pdf)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: ")
        print(sys.argv[0] + "<path to pdf file>")
        exit(1)
    path = sys.argv[1]
    path = os.path.abspath(path)
    dest_dir = os.path.dirname(path)
    get_duplex_printing_pdf(path, dest_dir)
