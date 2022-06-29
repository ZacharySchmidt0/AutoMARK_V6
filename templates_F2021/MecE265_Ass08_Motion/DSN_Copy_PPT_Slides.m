% used to copy the sldies from one PPT into another

path = 'T:\common265\a_Tutorials and Assignments\Tut_Ass_8 Motion\Win 2018\';
filespec1 = 'MecE_265_MOTION_test1.ppt';
filespec2 = 'MecE_265_MOTION_test2.ppt';

ppt = actxserver('PowerPoint.Application');
op1 = invoke(ppt.Presentations,'Open',[path filespec1],[],[],0);
op2 = invoke(ppt.Presentations,'Open',[path filespec2],[],[],0);

slide_count1 = get(op1.Slides,'Count');
slide_count2 = get(op2.Slides,'Count');

k =slide_count2+1;
for i = 1 : slide_count1
  invoke(op1.Slides.Item(i),'Copy')
  invoke(op2.Slides,'Paste')
% invoke(op2.Item(k).Slides,'Paste)
  k = k+1
end
invoke(op2,'Save');
% invoke(op2,'SaveAs',filespec2,1);
invoke(op1,'Close');
invoke(op2,'Close');
invoke(ppt,'Quit');
