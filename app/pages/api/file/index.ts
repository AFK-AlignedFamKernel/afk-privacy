import {Readable} from 'node:stream';

import {NextRequest, NextResponse} from 'next/server';

import {pinata} from '@/services/pinata';
import {ErrorCode} from '@/utils/errors';
import {HTTPStatus} from '@/utils/http';
import { NextApiRequest } from 'next';

export default async function POST(request: NextApiRequest) {
  const data = await request.body;
  const file: File | null = data?.file as unknown as File;

  // console.log("file", file);
  if (!file) {
    return NextResponse.json({code: ErrorCode.BAD_REQUEST}, {status: HTTPStatus.BadRequest});
  }

  try {
    const stream = Readable.fromWeb(file.stream() as any);
    console.log("stream", stream);
    const {IpfsHash} = await pinata.pinFileToIPFS(stream, {
      pinataMetadata: {
        name: file.name,
      },
    });

    return NextResponse.json(
      {hash: IpfsHash, url: `${process.env.IPFS_GATEWAY}/${IpfsHash}`},
      {status: HTTPStatus.OK},
    );
  } catch (error) {
    console.error(error);

    return NextResponse.json(
      {code: ErrorCode.TRANSACTION_ERROR, error},
      {status: HTTPStatus.InternalServerError},
    );
  }
}
