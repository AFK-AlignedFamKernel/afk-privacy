import { NextApiRequest, NextApiResponse } from 'next';
import { IncomingForm } from 'formidable';
import { createReadStream } from 'fs';
import { pinata } from '@/services/pinata';
import { ErrorCode } from '@/utils/errors';
import { HTTPStatus } from '@/utils/http';


// Add this configuration for handling file uploads
export const config = {
  api: {
    bodyParser: false, // Disables the default body parser
  },
};

export default async function handler(req: NextApiRequest, res: NextApiResponse) {
  if (req.method !== 'POST') {
    return res.status(404).json({ 
      code: ErrorCode.BAD_REQUEST 
    });
  }

  try {
    // Use formidable to parse multipart form data
    const formData = await new Promise((resolve, reject) => {
      const form = new IncomingForm();
      
      form.parse(req, (err: any, fields: any, files: any) => {
        if (err) return reject(err);
        resolve({ fields, files });
      });
    });

    const { files } = formData as any;
    const file = files.file?.[0];  // formidable returns an array

    if (!file) {
      return res.status(HTTPStatus.BadRequest).json({ 
        code: ErrorCode.BAD_REQUEST 
      });
    }

    // Create a readable stream from the temporary file
    const stream = createReadStream(file.filepath);

    const { IpfsHash } = await pinata.pinFileToIPFS(stream, {
      pinataMetadata: {
        name: file.originalFilename,
      },
    });

    return res.status(HTTPStatus.OK).json({ 
      hash: IpfsHash, 
      url: `${process.env.IPFS_GATEWAY}/${IpfsHash}` 
    });

  } catch (error) {
    console.error(error);
    return res.status(HTTPStatus.InternalServerError).json({ 
      code: ErrorCode.TRANSACTION_ERROR, 
      error 
    });
  }
}