function [synth_mask, synth_mask_number_of_ones, phi]=load_synthetic_masks(directory, extension, crop_mask, plot)

D=dir([directory,'*',extension]);
directory_scene=directory;

numberOfFiles = length(D(not([D.isdir])));

for i=1:numberOfFiles
    synth_mask{i}=im2double((imread([directory_scene, num2str(i,'mask_%0.03d'),extension])));
    
    if(crop_mask.bool)
        synth_mask{i}=imcrop(synth_mask{i},[crop_mask.roi_x_start crop_mask.roi_y_start crop_mask.block_size crop_mask.block_size]);
    end
    
    synth_mask_number_of_ones(i)=sum(synth_mask{i}(:));
    
end

for i=1:length(synth_mask)
    % create measurement matrix from different measurement masks
    measurement_vector{i}=synth_mask{i}(:);
    
    if(i==1)
        measurement_matrix=measurement_vector{1};
    else
        measurement_matrix=[measurement_matrix measurement_vector{i}];
    end
    if(plot)
        % plot measurement masks
        figure(100), imagesc(reshape(measurement_matrix(:,i),[8 8])), colormap gray, title('Measurement mask'), drawnow
    end
end
%     measurement_matrix=measurement_matrix';
if(plot)
    % plot measurement matrix
    figure, imagesc(measurement_matrix), colormap gray, title('Measurement matrix - columwise')
end

phi=measurement_matrix';