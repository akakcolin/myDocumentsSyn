#/bin/env python
import os
import sys

f= "1_p0_20"
#number of molecules in each file--delete this line in bracket)
split_number= 1 
number_of_sdfs = split_number
i=0
j=0
sdf_list=[]
one_sdf_filename=f+'_'+str(j)+'.sdf'
sdf_list.append(one_sdf_filename)
f2=open(one_sdf_filename,'w')
for line in open(f+'.sdf'):
    f2.write(line)
    if line[:4] == "$$$$":
       if i > number_of_sdfs:
          number_of_sdfs += split_number
          f2.close()
	  j+=1
          tmp_sdf_filename = f+'_'+str(j)+'.sdf'
          sdf_list.append(tmp_sdf_filename)
          f2=open(tmp_sdf_filename,'w')
       i+=1
#print(i)

babel_batch=f+'_babel_batch'
f3=open(babel_batch,'w')
for single_sdf in sdf_list:
   line = single_sdf.split(".")[0]
   head=(line.split(".")[0])
   command_line ="babel -isdf "+ line + ".sdf -oxyz " + head +".xyz --gen3D && rm  " + line + ".sdf \n"
   f3.write(command_line)
print(babel_batch)
xtb_batch =f+'_xtb_batch'
print(xtb_batch)
for single_sdf in sdf_list:
   line = single_sdf.split(".")[0]
   head=(line.split(".")[0])
   command_line ="mkdir "+ line + " && cd " + line + "  && xtb ../" + line +".xyz -o >/dev/null && mv xtbopt.xyz " + line+"_opt.xyz && rm xtbopt.log wbo xtbrestart \n"
   f3.write(command_line)
awk_batch=f+'_awk_batch'
print(awk_batch)
for single_sdf in sdf_list:
    line = single_sdf.split(".")[0]
    head=(line.split(".")[0])
    command_line="awk -v  text=`awk '{if(NR==2) print $0}' " +head+".xyz` '{if(NR==2) $0=text; print $0}' "+ head+"/"+head+"_opt.xyz > "+head+"_opt2.xyz && rm -rf " +head+" && rm "+head+".xyz \n"
    f3.write(command_line)
