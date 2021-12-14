figs = openfig('Combined.fig');
%% 

for K = 1 : length(figs)
   filename = 'CharacteristicParagraph.jpg';
   saveas(figs(K), filename);
end