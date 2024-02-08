sets students /s1*s50/;
    
alias (students,i);

binary variables
             female(i)
             male(i)
             num300(i)
             num340(i)
             num400(i)
             undergrad(i)
             CS(i)
             MATH(i)
             IE(i)
             graddec(i)
             under_IE(i)
             m_IE_under(i)
             f_underDec_IE_300and400(i)
             m_under_IE_300and400(i)
             m_underDec_IE(i)
             f_under_IE(i)
             m_under_IE(i);

variable maxfemale;

equations
        objective
        objectivelo
        objectiveup
        take400
        numfemale
        numundergrad
        numDec
        numIE
        numMath
        numCS
        ienumundergrad
        take300or340
        take300
        take340
        maleCons
        ieundergradup
        ieundergradlo
        ieundergradlomale
        ieundergradupmale
        fandm
        f_under_IE_upCon
        f_under_IE_loCon
        m_under_IE_loCon
        m_under_IE_upCon
        maleloCon
        maleupCon
        maleloCon2
        maleupCon2;


take300or340..
sum(i,num300(i))+sum(i,num340(i))=g=50;

take340..
sum(i,num340(i))=g=10;

take400..
sum(i,num400(i))=e=15;

take300..
sum(i,num300(i))=g=10;

numfemale..
sum(i,female(i))=e=15;

numundergrad..
sum(i,undergrad(i))=e=20;

numCS..
sum(i,cs(i))=e=25;

numMath..
sum(i,math(i))=e=15;

numIE..
sum(i,IE(i))=e=10;

numDec..
sum(i,graddec(i))=e=12;

ieundergradlo(i)..
ie(i)+undergrad(i)=g=2*under_IE(i);

ieundergradup(i)..
ie(i)+undergrad(i)-1=l=under_IE(i);

ieundergradlomale(i)..
ie(i)+undergrad(i)+male(i)=g=3*m_IE_under(i);

ieundergradupmale(i)..
ie(i)+undergrad(i)+male(i)-2=l=m_IE_under(i);

ienumundergrad..
sum(i,m_IE_under(i))=g=[2/3]*sum(i,under_IE(i));

objectivelo(i)..
female(i)+ie(i)+undergrad(i)+graddec(i)+num300(i)+num400(i)=g=6*f_underDec_IE_300and400(i);

objectiveup(i)..
female(i)+ie(i)+undergrad(i)+graddec(i)+num300(i)+num400(i)-5=l=f_underDec_IE_300and400(i);

objective..
maxfemale=e=sum(i,f_underDec_IE_300and400(i));

f_under_IE_loCon(i)..
3*f_under_IE(i)=l=female(i)+ie(i)+undergrad(i);

f_under_IE_upCon(i)..
female(i)+ie(i)+undergrad(i)-2=l=f_under_IE(i);

m_under_IE_loCon(i)..
3*m_under_IE(i)=l=male(i)+ie(i)+undergrad(i);

m_under_IE_upCon(i)..
m_under_IE(i)=g=male(i)+ie(i)+undergrad(i)-2;

maleloCon(i)..
male(i)+ie(i)+undergrad(i)+num300(i)+num400(i)=g=5*m_under_IE_300and400(i);

maleupCon(i)..
male(i)+ie(i)+undergrad(i)+num300(i)+num400(i)-4=l=m_under_IE_300and400(i);

maleloCon2(i)..
male(i)+ie(i)+undergrad(i)+graddec(i)=g=4*m_underDec_IE(i);

maleupCon2(i)..
male(i)+ie(i)+undergrad(i)+graddec(i)-3=l=m_underDec_IE(i);

maleCons..
sum(i,m_under_IE_300and400(i))+sum(i,m_underDec_IE(i))=e=2;

fandm(i)..
male(i)+female(i)=e=1;


model maxfemengineer /all/;

solve maxfemengineer using mip maximizing maxfemale;

parameter results(*);
results('exists')$(maxfemale.l>0) =1; 
results('max howmany') = maxfemale.l;
results('femIEugrads') = sum(i,f_under_IE.l(i)); 
results('maleIEudrads') = sum(i,m_under_IE.l(i));
display results;


