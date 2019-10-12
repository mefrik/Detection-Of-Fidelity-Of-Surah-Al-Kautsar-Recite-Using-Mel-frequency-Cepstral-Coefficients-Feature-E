

% Fungsi melakukan filter pre-emphasize
function Kata_pre = filterpreemphasize(input)
% Memfilter input dengan filter preemphasis. juga mengetahui berapa jumlah
% kolom data yang akan berakhir
% if 1
% 	preEmphasized = filter([1 -.97], 1, input);
% else
% 	preEmphasized = input;
% end
if size(input,2) == 1
    nargout = filter([1 -.9375], 1, input);
else
    for m = 1 : size(input,2)
        for n = 1 : size(input,1)
            Kata_pre{n,m} = filter([1 -.9375], 1, input{n,m});
        end
    end
end


